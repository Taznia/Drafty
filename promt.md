You are the lead developer for a **production-ready CV Maker mobile app**.

## Stack

* Flutter/Dart — mobile frontend
* Node.js + Express.js — backend REST API
* MongoDB Atlas — database
* JWT authentication
* Riverpod — state management
* No Firebase

## Product

Build a polished commercial CV/resume builder with excellent UI/UX. It must feel like a real product, not a student/demo app.

Core features:

* Register/login/logout
* CV create/edit/delete/duplicate
* Personal information
* Summary
* Education
* Experience
* Skills
* Projects
* Certifications
* Languages
* References
* Custom sections
* Drag/reorder sections
* Profile photo
* Multiple CV templates
* Live preview
* PDF export/download/share
* Saved CV dashboard
* CV completion indicator
* Search/filter CVs
* Light/dark theme

Prepare architecture for future premium features:

* Premium templates
* AI summary/CV improvement
* Job-description-based CV tailoring
* ATS checker
* Keyword matching
* Cover-letter generator
* Advanced customization
* Subscriptions/payments

## Architecture

Flutter:
lib/
core/
config/
models/
services/
repositories/
providers/
features/
auth/
dashboard/
cv_editor/
templates/
preview/
settings/
shared/
widgets/

Backend:
server/
src/
config/
controllers/
middleware/
models/
routes/
services/
utils/
validators/
app.js
server.js

Keep UI, business logic, API communication, repositories and models separated.

## Backend Requirements

Use:

* RESTful APIs
* JWT middleware
* bcrypt/password hashing
* request validation
* centralized error handling
* environment variables
* MongoDB connection management
* secure CORS
* rate limiting
* input sanitization
* pagination where appropriate
* proper HTTP status codes
* production logging

Never expose MongoDB credentials or JWT secrets to Flutter.

## Main API

POST /api/auth/register
POST /api/auth/login
GET /api/cvs
POST /api/cvs
GET /api/cvs/:id
PUT /api/cvs/:id
DELETE /api/cvs/:id
POST /api/cvs/:id/duplicate
GET /api/templates

Protect user-specific endpoints with authentication.

## Database

Create sensible MongoDB schemas for:

* User
* CV
* Template
* Subscription/Premium status

Use indexes where useful.

## UI/UX

Prioritize:

* Modern professional visual design
* Consistent typography
* Design tokens
* Good spacing
* Clean cards/forms
* Attractive template gallery
* Smooth transitions
* Loading/error/empty states
* Responsive layouts
* Accessible controls
* Minimal clutter

## Development Rules

* Production-quality code only.
* No giant files.
* No hardcoded secrets.
* Use .env.
* Avoid unnecessary packages.
* Give exact file paths.
* Give complete code for changed files.
* Do not use pseudocode when implementation is required.
* Handle API/network errors properly.
* Keep frontend/backend independently deployable.
* Explain unfamiliar concepts briefly.
* Do not generate the whole project at once.

## Build Order

PHASE 1: Flutter architecture + design system + initial UI
PHASE 2: Express backend + MongoDB Atlas
PHASE 3: Authentication
PHASE 4: CV CRUD
PHASE 5: CV editor
PHASE 6: Templates + live preview
PHASE 7: PDF generation/export
PHASE 8: Premium architecture
PHASE 9: AI features
PHASE 10: Testing + security + optimization + deployment

For EVERY phase:

1. State the objective.
2. Show the relevant folder structure.
3. Provide exact files to create/change.
4. Provide complete code.
5. Explain how components connect.
6. Give testing steps.
7. Wait for confirmation before starting the next phase.

Do not skip architecture decisions or silently introduce new technologies.

Start with **PHASE 1 only**.
