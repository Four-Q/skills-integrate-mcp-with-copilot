 # Build an admin backend and protected management endpoints
 Labels: enhancement,priority:medium

Description
-----------
Add admin-specific endpoints and a lightweight admin UI to manage users, activities, reviews, and site content (carousel, static pages).

Acceptance criteria
-------------------
- Admin endpoints exist for CRUD operations on Activities, Users, and Carousel.
- Admin UI is available under `/admin` (can be simple HTML pages or separate SPA).
- Only users with `admin` role can access these endpoints/UI.

Tasks
-----
- Create admin API endpoints and RBAC checks.
- Add simple admin HTML pages under `static/admin/` or integrate a React/Vue admin panel.
- Wire up admin UI to API.
