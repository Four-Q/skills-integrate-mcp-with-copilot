 # Persist activities and signups to a database
 Labels: enhancement,priority:high

Description
-----------
Replace the in-memory `activities` dictionary with persistent storage. Create normalized tables for activities, users and signups so data survives restarts.

Acceptance criteria
-------------------
- Activities, Users, and Signups are stored in a relational database (SQLite/Postgres).
- Existing API endpoints continue to work but backed by the DB.
- A simple migration or initial seed script exists to populate example activities.

Tasks
-----
- Add ORM models: `Activity`, `User`, `Signup`.
- Implement DB connection and session handling.
- Convert `/activities`, `/signup`, `/unregister` to use DB.
- Add initial seed data script.

Notes
-----
Use SQLAlchemy + Alembic for migrations (or Tortoise/Ormar if preferred for async).
