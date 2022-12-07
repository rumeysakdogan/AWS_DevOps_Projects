# Import Flask modules
from flask import Flask, request, render_template
from flaskext.mysql import MySQL

# Create an object named app
app = Flask(__name__)

# This "/home/ec2-user/dbserver.endpoint" file has to be created from cloudformation template and it has RDS endpoint
db_endpoint = open("/home/ec2-user/dbserver.endpoint", 'r', encoding='UTF-8') 

# Configure mysql database

app.config['MYSQL_DATABASE_HOST'] = db_endpoint.readline().strip()
app.config['MYSQL_DATABASE_USER'] = 'admin'
app.config['MYSQL_DATABASE_PASSWORD'] = 'Please_Enter_Your_DB_Password'
app.config['MYSQL_DATABASE_DB'] = 'clarusway_phonebook'
app.config['MYSQL_DATABASE_PORT'] = 3306
db_endpoint.close()
mysql = MySQL()
mysql.init_app(app) 
connection = mysql.connect()
connection.autocommit(True)
cursor = connection.cursor()

# Write a function named `init_todo_db` create phonebook table within clarusway_phonebook db, if it doesn't exist

def init_phonebook_db():
    phonebook_table = """
    CREATE TABLE IF NOT EXISTS clarusway_phonebook.phonebook(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    number VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    """
    cursor.execute(phonebook_table) # This is the connection to our database.

# Write a function named `find_persons` which finds persons' record using the keyword from the phonebook table in the db,and returns result as list of dictionary 
# `[{'id': 1, 'name':'XXXX', 'number': 'XXXXXX'}]`.

# This function is to find my results that has "keyword" into database
def find_persons(keyword):
    query = f"""
    SELECT * FROM phonebook WHERE name like '%{keyword.strip().lower()}%';
    """
    cursor.execute(query)
    result = cursor.fetchall() 
    persons =[{'id':row[0], 'name':row[1].strip().title(), 'number':row[2]} for row in result] 
    if len(persons) == 0: 
        persons = [{'name':'No Result', 'number':'No Result'}] 
    return persons


# Write a function named `insert_person` which inserts person into the phonebook table in the db,
# and returns text info about result of the operation

def insert_person(name, number):
    query = f"""
    SELECT * FROM phonebook WHERE name like '{name.strip().lower()}';
    """
    cursor.execute(query)
    row = cursor.fetchone()
    if row is not None: 
        return f'Person with name {row[1].title()} already exits.'
    insert = f"""
    INSERT INTO phonebook (name, number)
    VALUES ('{name.strip().lower()}', '{number}');
    """
    cursor.execute(insert)
    result = cursor.fetchall()
    return f'Person {name.strip().title()} added to Phonebook successfully' # person given by user added to phonebook 

# Write a function named `update_person` which updates the person's record in the phonebook table,
# and returns text info about result of the operation
def update_person(name, number):
    query = f"""
    SELECT * FROM phonebook WHERE name like '{name.strip().lower()}';
    """
    cursor.execute(query)
    row = cursor.fetchone()
    if row is None: 
        return f'Person with name {name.strip().title()} does not exist.'
    update = f"""
    UPDATE phonebook
    SET name='{row[1]}', number = '{number}'
    WHERE id= {row[0]};
    """
    cursor.execute(update)

    return f'Phone record of {name.strip().title()} is updated successfully'


# Write a function named `delete_person` which deletes person record from the phonebook table in the db,
# and returns returns text info about result of the operation
def delete_person(name):
    query = f"""
    SELECT * FROM phonebook WHERE name like '{name.strip().lower()}';
    """
    cursor.execute(query)
    row = cursor.fetchone()
    if row is None:
        return f'Person with name {name.strip().title()} does not exist, no need to delete.'
    delete = f"""
    DELETE FROM phonebook
    WHERE id= {row[0]};
    """
    cursor.execute(delete) 
    return f'Phone record of {name.strip().title()} is deleted from the phonebook successfully'

# Write a function named `find_records` which finds phone records by keyword using `GET` and `POST` methods,
# using template files named `index.html` given under `templates` folder
# and assign to the static route of ('/')
@app.route('/', methods=['GET', 'POST'])
def find_records():
    if request.method == 'POST':
        keyword = request.form['username']
        persons_app = find_persons(keyword) 
        return render_template('index.html', persons_html=persons_app, keyword=keyword, show_result=True, developer_name='Rumeysa')
    else:
        return render_template('index.html', show_result=False, developer_name='Rumeysa')


# Write a function named `add_record` which inserts new record to the database using `GET` and `POST` methods,
# using template files named `add-update.html` given under `templates` folder
# and assign to the static route of ('add')
@app.route('/add', methods=['GET', 'POST'])
def add_record():
    if request.method == 'POST':
        name = request.form['username']
        if name is None or name.strip() == "":
            return render_template('add-update.html', not_valid=True, message='Invalid input: Name can not be empty', show_result=False, action_name='save', developer_name='Rumeysa')
        elif name.isdecimal(): 
            return render_template('add-update.html', not_valid=True, message='Invalid input: Name of person should be text', show_result=False, action_name='save', developer_name='Rumeysa')
        phone_number = request.form['phonenumber']
        if phone_number is None or phone_number.strip() == "": 
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number can not be empty', show_result=False, action_name='save', developer_name='Rumeysa')
        elif not phone_number.isdecimal(): 
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number should be in numeric format', show_result=False, action_name='save', developer_name='Rumeysa')
        result_app = insert_person(name, phone_number)
        return render_template('add-update.html', show_result=True, result_html=result_app, not_valid=False, action_name='save', developer_name='Rumeysa') 
    else:
        return render_template('add-update.html', show_result=False, not_valid=False, action_name='save', developer_name='Rumeysa')

# Write a function named `update_record` which updates the record in the db using `GET` and `POST` methods,
# using template files named `add-update.html` given under `templates` folder
# and assign to the static route of ('update')
@app.route('/update', methods=['GET', 'POST'])
def update_record():
    if request.method == 'POST':
        name = request.form['username']
        if name is None or name.strip() == "":
            return render_template('add-update.html', not_valid=True, message='Invalid input: Name can not be empty', show_result=False, action_name='update', developer_name='Rumeysa')
        phone_number = request.form['phonenumber']
        if phone_number is None or phone_number.strip() == "":
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number can not be empty', show_result=False, action_name='update', developer_name='Rumeysa')
        elif not phone_number.isdecimal():
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number should be in numeric format', show_result=False, action_name='update', developer_name='Rumeysa')

        result_app = update_person(name, phone_number) 
        return render_template('add-update.html', show_result=True, result_html=result_app, not_valid=False, action_name='update', developer_name='Rumeysa') 
    else:
        return render_template('add-update.html', show_result=False, not_valid=False, action_name='update', developer_name='Rumeysa')

# Write a function named `delete_record` which updates the record in the db using `GET` and `POST` methods,
# using template files named `delete.html` given under `templates` folder
# and assign to the static route of ('delete')
@app.route('/delete', methods=['GET', 'POST'])
def delete_record():
    if request.method == 'POST':
        name = request.form['username']
        if name is None or name.strip() == "":
            return render_template('delete.html', not_valid=True, message='Invalid input: Name can not be empty', show_result=False, developer_name='Rumeysa')
        result_app = delete_person(name)
        return render_template('delete.html', show_result=True, result_html=result_app, not_valid=False, developer_name='Rumeysa') 
    else:
        return render_template('delete.html', show_result=False, not_valid=False, developer_name='Rumeysa')


# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__== '__main__':
    init_phonebook_db()
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=80) 
