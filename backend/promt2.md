You have already implemented Phases 1–9 of this CV Maker app. DO NOT rebuild the entire project from scratch.

First inspect the existing Flutter frontend, Node.js/Express backend, MongoDB models/APIs, navigation, state management, CV editor, templates, authentication and PDF/preview functionality.

Keep everything that already works. Fix/refactor only where necessary. Do not unnecessarily change the backend architecture or break existing APIs.

I want a major **UI/UX redesign + feature completion**.

## 1. NEW UI/UX DIRECTION

Use the attached reference image as the visual inspiration.

Target style:

* Premium modern SaaS/product UI
* Dark charcoal/deep navy base
* Coral/salmon accent similar to the reference
* Rounded cards and buttons
* Clean typography
* Strong spacing and visual hierarchy
* Modern sidebar/bottom navigation
* Elegant icons
* Professional dashboard
* Subtle shadows/elevation
* Smooth but restrained animations
* Visually rich template cards
* Avoid generic/basic Flutter UI
* Avoid excessive white cards and default Material styling
* Make the app feel like a commercial product

Do NOT copy the reference image (image.png) literally. Use its visual language and design direction. 

Create a consistent design system:

* Colors
* Typography
* Border radius
* Spacing
* Button styles
* Input styles
* Cards
* Navigation
* Dialogs
* Empty/loading/error states

The entire app must follow the same design system, not only the dashboard.

## 2. APP THEME

Add proper theme support:

* Dark theme
* Light theme
* Black theme
* White/minimal theme

The user must be able to switch themes from Settings/Profile.

The Black/White options should affect the APP UI, not the CV templates.

Persist the selected app theme.

## 3. REDESIGN APP LAYOUT

Redesign the overall navigation/layout.

Main areas should include something similar to:

* Dashboard
* My CVs
* Templates
* Create CV
* Profile/Account
* Settings

Use the most appropriate navigation pattern for mobile.

Dashboard should feel like a real CV product:

* Welcome/header area
* Create New CV CTA
* Recent CVs
* Template shortcuts
* CV completion/progress
* Useful actions
* Clean empty states

Do not overcrowd the dashboard.

## 4. CV CREATION / EDITOR

When the user creates a CV, they must be able to manage all CV content properly.

Sections should include:

* Personal Information
* Profile/Summary
* Experience
* Education
* Skills
* Projects
* Certifications
* Languages
* References
* Awards
* Interests
* Custom Sections

Each section must actually appear in the generated CV/preview after being added.

### Important bug:

Currently, adding a new section does not properly appear in the CV.

FIX THE DATA FLOW:

Editor → state/model → backend/database if applicable → CV preview/template renderer → PDF

Make sure newly added sections are rendered by the selected template.

Do not create UI-only sections that disappear from the actual CV.

## 5. SECTION REORDERING

The user must have complete control over section order.

Example:

Personal Info
Summary
Experience
Projects
Education
Skills

OR:

Personal Info
Summary
Education
Skills
Projects
Experience

The user should be able to drag/reorder sections.

The selected order must be preserved in:

* editor
* preview
* saved CV
* PDF

Do not hardcode section order inside templates.

Templates should control styling/layout, while the user's selected section order should control content order where the template permits it.

## 6. TEMPLATE SELECTION

Currently, users cannot easily change the template while creating/editing a CV.

Add:

**Change Template**

inside the CV editor.

The user should be able to:

* Open template gallery
* Preview templates
* Select another template
* Immediately see the CV using the new template
* Keep all existing CV data when changing templates

Changing a template must NOT delete CV content.

## 7. MORE PROFESSIONAL TEMPLATES

The current number of templates is insufficient.

Create a significantly larger template system with multiple genuinely different layouts.

Include template categories/styles inspired by common professional resume formats, such as:

* ATS-friendly
* Modern
* Minimal
* Corporate
* Executive
* Creative
* Academic
* Tech
* Two-column
* Single-column
* Compact
* Professional
also add FAANGPath formet cv

Include formats inspired by commonly used resume structures such as FAANG-style/FAANGPath-style resumes, but DO NOT copy proprietary template designs/assets exactly. Create original layouts with similar professional principles.

Each template should have:

* Unique layout
* Typography
* Section styling
* Spacing
* Header treatment
* Optional colors
* Proper PDF rendering
* ATS-friendly option where appropriate

Build the template system so adding future templates is easy.

## 8. FULL-SCREEN CV PREVIEW

Current problem:

When I click Preview, the CV only appears on part of the screen.

Fix this.

The preview screen should use the **entire available screen**.

Requirements:

* Full-screen CV viewer
* Proper page proportions
* Zoom in/out
* Fit-to-screen
* Scroll through multiple pages
* Page navigation if useful
* No unnecessary editor panels taking half the screen
* Clear Edit button
* Download/export button
* Share button

On mobile, the CV should remain readable and properly scaled.

The preview and PDF renderer should use the same CV data and template rendering logic.

## 9. PROFILE PHOTO

Add the ability to add/change/remove a profile photo.

User flow:

Profile/CV Editor
→ Add Photo
→ Pick from gallery/camera where supported
→ Crop/resize if appropriate
→ Preview
→ Save

The selected photo must actually appear in templates that support profile photos.

Templates that don't use photos should simply omit it.

Handle image storage correctly. Do not put large raw images directly into inappropriate database fields.

## 10. LINKS

CV entries must support clickable links.

Examples:

* Portfolio
* LinkedIn
* GitHub
* Personal website
* Project URL
* Behance
* Other custom links

For projects, allow:

Project name
Description
Technologies
Project URL
GitHub URL
Other relevant links

Links should appear correctly in:

* CV preview
* PDF where technically supported
* Saved CV data

## 11. PROFILE / ACCOUNT

The current Profile functionality is broken/missing.

Implement a working Profile/Account screen.

It should display/edit:

* Name
* Email
* Profile photo
* Account information
* App theme
* Settings
* Logout

Use the existing backend/authentication system instead of creating a second authentication system.

## 12. LOGIN / SIGNUP / LOGOUT

Authentication UI is currently missing.

Implement:

### Login

* Email
* Password
* Login
* Forgot password placeholder if backend support is not implemented yet

### Sign Up

* Name
* Email
* Password
* Confirm password

### Logout

* Logout from Profile/Settings
* Clear authentication state safely
* Return to Login screen

Use the existing JWT authentication APIs.

Do not store passwords locally.

Persist authentication securely using an appropriate secure storage solution.

Handle:

* Invalid credentials
* Expired token
* Network errors
* Loading states
* Logout

## 13. CV DATA MODEL

Review the existing CV model.

Make sure it can support:

* Personal information
* Photo
* Contact information
* Social/portfolio links
* Summary
* Experience
* Education
* Skills
* Projects + links
* Certifications
* Languages
* Awards
* Interests
* References
* Custom sections
* Section ordering
* Selected template
* Template settings
* Created/updated timestamps

Do not unnecessarily redesign the database if the existing model can be extended safely.

Use migrations/backward-compatible handling where needed.

## 14. TEMPLATE CUSTOMIZATION

Allow users to customize supported template properties such as:

* Accent color
* Font
* Font size
* Spacing
* Section heading style
* Photo visibility

Do not let customization destroy the template's intended layout.

## 15. RESPONSIVENESS

The app must work properly on different phone sizes.

Check:

* Small Android devices
* Large Android devices
* Different aspect ratios

Avoid:

* overflow
* clipped text
* buttons going off-screen
* keyboard covering fields
* broken scrolling
* tiny CV preview

## 16. IMPORTANT DEVELOPMENT RULE

Before modifying code:

1. Inspect the current implementation.
2. Identify existing working functionality.
3. Identify the files responsible for each issue.
4. Reuse existing architecture where possible.
5. Do not create duplicate models/services/providers.
6. Do not create a second API system.
7. Do not break working backend endpoints.
8. Do not replace MongoDB Atlas.
9. Do not replace Node.js/Express.
10. Do not remove existing functionality unless necessary.

## IMPLEMENTATION ORDER

Do NOT implement everything in one huge change.

Work in this order:



### Step 2

Redesign global UI/design system + navigation/dashboard.

### Step 3

Fix authentication + Profile + Login/Signup/Logout.

### Step 4

Fix CV editor/data flow + custom sections.

### Step 5

Implement section reordering.

### Step 6

Implement template selection/change-template flow.

### Step 7

Expand template library.

### Step 8

Fix full-screen preview/PDF rendering.

### Step 9

Add photo + links + project URLs.

### Step 10

Add app themes and template customization.

### Step 11

Test the complete user flow.

For each step:

* Show which files will change.
* Explain what you are changing briefly.
* Make the changes.
* Check for compile errors.
* Check for broken imports/routes/providers.
* Test the affected functionality.
* Do not move to the next step until the current step is stable.

Most importantly: **prioritize a polished, coherent product UI over simply adding more screens.**
