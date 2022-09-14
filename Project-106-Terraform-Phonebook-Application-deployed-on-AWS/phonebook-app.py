# To show this app works fine, we need to create a RDS instance at first.

# Import Flask modules
# As we know, we are gonna import necessary libraries. We've also imported
from flask import Flask, request, render_template
from flaskext.mysql import MySQL

# Create an object named app
app = Flask(__name__)

# The hardest part of this project is to get endpoint of RDS instances. Since our RDS is created within cloudformation template, we need to get RDS endpoint and paste it here as environmental variable using Launch templates user data.
db_endpoint = open(
    "/home/ec2-user/phonebook/dbserver.endpoint", 'r', encoding='UTF-8')

# Configure mysql database

# Once we are done with the database, we are going to create database.
# we need to configure our database. I've explained this part before. Lets have a look at these configuration.
app.config['MYSQL_DATABASE_HOST'] = db_endpoint.readline().strip()
app.config['MYSQL_DATABASE_USER'] = 'admin'
app.config['MYSQL_DATABASE_PASSWORD'] = 'Oliver_1'
app.config['MYSQL_DATABASE_DB'] = 'phonebook'
app.config['MYSQL_DATABASE_PORT'] = 3306
db_endpoint.close()
mysql = MySQL()  # We are using this function to initialize mysql
mysql.init_app(app)
connection = mysql.connect()
connection.autocommit(True)
cursor = connection.cursor()

# Write a function named `init_todo_db` create phonebook table within clarusway_phonebook db, if it doesn't exist

# Lets paste Because of the id is auto_incremental, I don't need to worry about to id column. mysql is going to give id on behalf of us.


def init_phonebook_db():
    phonebook_table = """
    CREATE TABLE IF NOT EXISTS phonebook.phonebook(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    number VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    """
    cursor.execute(phonebook_table)  # This is the connection to our database.

# Write a function named `find_persons` which finds persons' record using the keyword from the phonebook table in the db,and returns result as list of dictionary
# `[{'id': 1, 'name':'XXXX', 'number': 'XXXXXX'}]`.

# This function is to find my results that has "keyword" into database


def find_persons(keyword):
    # You are very familiar with this query. This query will select all columns where the name like keyword. strip will remove all the white spaces, and lower will turn uppercase into lowercase.
    query = f"""
    SELECT * FROM phonebook WHERE name like '%{keyword.strip().lower()}%';
    """
    cursor.execute(query)  # We've executed query first
    #  I've got the result and assign them result variable.
    result = cursor.fetchall()
    #  this is a list comprehension, if there is a result coming from database, They are located these results one by one into the list and assigned it to the person variable. title makes the first letter capital
    persons = [{'id': row[0], 'name':row[1].strip().title(), 'number':row[2]}
               for row in result]
    # if there is no result, thanks to this if condition, No result massages is assigned to the persons variable.
    if len(persons) == 0:
        persons = [{'name': 'No Result', 'number': 'No Result'}]
    return persons


# Write a function named `insert_person` which inserts person into the phonebook table in the db,
# and returns text info about result of the operation

# We've defined insert_person function. at this time, I'll put name and number as parameter.
def insert_person(name, number):
    # We've first checked if there is a same person in my database. Thats why, I need to use exact name here with strip and lower methods.
    query = f"""
    SELECT * FROM phonebook WHERE name like '{name.strip().lower()}';
    """
    cursor.execute(query)
    row = cursor.fetchone()
    if row is not None:  # If the row is not none, it means, I have a row that has same name given by a user, We'll return user with a massage
        return f'Person with name {row[1].title()} already exits.'

    # If our database doesn't have any name given by user, we can add that name into it.
    insert = f"""
    INSERT INTO phonebook (name, number)
    VALUES ('{name.strip().lower()}', '{number}');
    """
    cursor.execute(insert)
    result = cursor.fetchall()
    # person given by user added to phonebook
    return f'Person {name.strip().title()} added to Phonebook successfully'

# Write a function named `update_person` which updates the person's record in the phonebook table,
# and returns text info about result of the operation


def update_person(name, number):
    query = f"""
    SELECT * FROM phonebook WHERE name like '{name.strip().lower()}';
    """
    cursor.execute(query)
    row = cursor.fetchone()
    if row is None:  # First we need to control if there is any person with the same name into our database. if we don't have, a warning massage will raise
        return f'Person with name {name.strip().title()} does not exist.'
    # if there is a person with the given name, we can update it.
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
    if row is None:  # Again we need to control if we have this person. then, If we don't have, there is seen a warning massage like this
        return f'Person with name {name.strip().title()} does not exist, no need to delete.'

    # If we have this person, we'll delete his row using the querry.
    delete = f"""
    DELETE FROM phonebook
    WHERE id= {row[0]};
    """
    cursor.execute(delete)  # And a magssage will be shown to be informed.
    return f'Phone record of {name.strip().title()} is deleted from the phonebook successfully'

# Write a function named `find_records` which finds phone records by keyword using `GET` and `POST` methods,
# using template files named `index.html` given under `templates` folder
# and assign to the static route of ('/')


@app.route('/', methods=['GET', 'POST'])
def find_records():
    if request.method == 'POST':
        keyword = request.form['username']
        # to avoid confusion, I use person_app in this application, and use person_html for html file.
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
        # I'll get input from html file and assign it to name variable
        name = request.form['username']
        if name is None or name.strip() == "":
            return render_template('add-update.html', not_valid=True, message='Invalid input: Name can not be empty', show_result=False, action_name='save', developer_name='Rumeysa')
        elif name.isdecimal():  # This will check if the name given by user has any decimal character. If it has, a warning massage will raise
            return render_template('add-update.html', not_valid=True, message='Invalid input: Name of person should be text', show_result=False, action_name='save', developer_name='Rumeysa')
        # We'll check the phone number given by user here
        phone_number = request.form['phonenumber']
        # The user may have forgotten to give a number. This function will control whether the phone number is empty or not. if it is empty, a warning massage will be raising.
        if phone_number is None or phone_number.strip() == "":
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number can not be empty', show_result=False, action_name='save', developer_name='Rumeysa')
        # This function will check if the number has at least one non-numeric character. If it has, again a massage will raise.
        elif not phone_number.isdecimal():
            return render_template('add-update.html', not_valid=True, message='Invalid input: Phone number should be in numeric format', show_result=False, action_name='save', developer_name='Rumeysa')
        # if everything is ok, whole those blocks will be passed, and we come here.
        result_app = insert_person(name, phone_number)
        # In addition, There is no message shown by user here. Thats why not valid is going to be False.
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
        # Again, There is no message shown by user here. Thats why not valid is going to be False.
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
        # In addition, There will be no message to be shown to the user here. Thats why not valid is going to be False.
        return render_template('delete.html', show_result=True, result_html=result_app, not_valid=False, developer_name='Rumeysa')
    else:
        return render_template('delete.html', show_result=False, not_valid=False, developer_name='Rumeysa')


# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ == '__main__':
    init_phonebook_db()
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=80)
