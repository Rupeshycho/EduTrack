
# EduTrack — Django School Management System

A simple, practical school management system built with Django, Python, and SQL.
It supports three roles — **Admin**, **Teacher**, and **Student** — with attendance
tracking, exam results, and centralized student/teacher records.

## Project Structure

```
edutrack/
├── manage.py
├── requirements.txt
├── edutrack/          # project settings, root urls
├── users/              # custom user model + auth (register/login/logout)
├── students/           # Student & SchoolClass models
├── teachers/            # Teacher model
├── attendance/          # daily attendance records
├── exams/               # exams & results
├── templates/           # shared layout.html + all app templates
├── static/css/style.css # single global stylesheet
└── sql/                 # hand-written MySQL schema + sample queries
    ├── schema.sql
    ├── sample_queries.sql
    └── README.md
```

## Setup

```bash
# 1. Create and activate a virtual environment
python -m venv .venv
.venv\Scripts\activate        # Windows
source .venv/bin/activate     # macOS/Linux

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run migrations
python manage.py makemigrations
python manage.py migrate

# 4. Create an admin account
python manage.py createsuperuser

# 5. Run the server
python manage.py runserver
```

Visit `http://127.0.0.1:8000/` for the homepage and `http://127.0.0.1:8000/admin/`
for the Django admin panel.

## Switching to MySQL or PostgreSQL

By default the project uses SQLite so it runs with zero setup. `edutrack/settings.py`
has ready-to-uncomment `DATABASES` :

- **PostgreSQL** — install `psycopg2-binary`, create the DB in pgAdmin
  (or `CREATE DATABASE edutrack_db;` in its Query Tool), uncomment the
  PostgreSQL block.

After switching just run `python manage.py migrate` again —
Django's ORM will create all the tables in the new database automatically.
See `sql/README.md` for hand-written schema/query files matching both engines.

## Roles

- **Admin** — manage everything through `/admin/` (students, teachers, classes, exams).
- **Teacher** — logs in and marks attendance at `/attendance/mark/`.
- **Student** — logs in and views results/attendance at `/exams/my-results/`.
**
_New users choose Student or Teacher at registration (`/users/register/`).
Admin accounts are created via `createsuperuser` and assigned the Admin role
in the admin panel._**

