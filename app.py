from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='127.0.0.1',
            port=3307,
            database='EventManagementSystem',
            user='root',
            password=''
        )
        return connection
    except Error as e:
        print(f"Database Connection Failure: {e}")
        return None

@app.route('/')
def index():
    conn = get_db_connection()
    if conn is None:
        return "Internal Server Error: Database Connection Failed.", 500
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT 
            e.event_id,
            e.title AS event_title,
            e.event_type,
            CONCAT(u.first_name, ' ', u.last_name) AS organizer_name,
            v.venue_name,
            e.start_date,
            (v.cost_per_day + COALESCE(SUM(es.agreed_price * es.quantity), 0)) AS total_cost
        FROM events e
        INNER JOIN users u ON e.organizer_id = u.user_id
        INNER JOIN venues v ON e.venue_id = v.venue_id
        LEFT JOIN event_services es ON e.event_id = es.event_id
        GROUP BY e.event_id;
    """
    cursor.execute(query)
    events_data = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('index.html', events=events_data)

@app.route('/add_event', methods=['POST'])
def add_event():
    title = request.form['title']
    event_type = request.form['type']
    start_date = request.form['start']
    end_date = request.form['end']
    venue_id = request.form['venue']
    organizer_id = request.form['organizer']
    
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        insert_query = """
            INSERT INTO events (title, event_type, start_date, end_date, venue_id, organizer_id)
            VALUES (%s, %s, %s, %s, %s, %s);
        """
        cursor.execute(insert_query, (title, event_type, start_date, end_date, venue_id, organizer_id))
        conn.commit()
        cursor.close()
        conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)