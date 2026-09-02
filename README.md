# POE_Part1

1. Project Overview

RaceDayDB is a database-backed event management system for running, walking and cycling events. It stores users, event types, events, event categories, participant enrolments and race results.

The database follows the supplied ERD and uses primary keys, foreign keys, unique constraints and check constraints to maintain data integrity. The project also includes an API endpoint plan for authentication, profiles, events, categories, enrolments and results.

2. Main Features

User registration and login

User profile management

Organiser event management

Event type management

Event category management

Participant enrolment

Race result management

Role-based access for organisers and participants

SQL data validation and integrity controls

3. Database Tables

User

Stores system users.

UserID - Primary Key

FirstName

LastName

Email

PasswordHash

PhoneNumber

Role

Allowed roles are Organiser and Participant. Email addresses are unique.

EventType

Stores event types.

EventTypeID - Primary Key

TypeName

Sample types are Run, Walk and Cycle.

Event

Stores events organised by users.

EventID - Primary Key

OrganizerID - Foreign Key to User(UserID)

EventName

Description

EventDate

Location

Distance

EventTypeID - Foreign Key to EventType(EventTypeID)

Category

Stores categories belonging to an event.

CategoryID - Primary Key

EventID - Foreign Key to Event(EventID)

CategoryName

MinimumAge

MaximumAge

CategoryDistance

Enrollment

Stores participant enrolments.

EnrollmentID - Primary Key

ParticipantID - Foreign Key to User(UserID)

EventID - Foreign Key to Event(EventID)

CategoryID - Foreign Key to Category(CategoryID)

EnrollmentDate

The database prevents the same participant from enrolling in the same event more than once through the unique constraint on ParticipantID, EventID.

Result

Stores results for completed enrolments.

ResultID - Primary Key

EnrollmentID - Foreign Key to Enrollment(EnrollmentID)

FinishTime

FinishingPosition

Each enrolment can have at most one result because EnrollmentID is unique.

4. ERD Relationships

One User can organise many Event records.

One EventType can be assigned to many Event records.

One Event can have many Category records.

One User can have many Enrollment records as a participant.

One Event can have many Enrollment records.

One Category can be selected by many Enrollment records.

One Enrollment can have zero or one Result.

These relationships match the supplied ERD and SQL foreign keys.

5. API Endpoint Plan

Authentication

Method

Route

Description

Role

POST

/api/auth/register

Register a new user

Public

POST

/api/auth/login

Authenticate a user

Public

POST

/api/auth/logout

End the authenticated session

Authenticated

User Profile

Method

Route

Description

Role

GET

/api/users/me

View own profile

Authenticated

PUT

/api/users/me

Update own profile

Authenticated

Events

Method

Route

Description

Role

GET

/api/events

View all events

Public/Authenticated

GET

/api/events/{eventId}

View one event

Public/Authenticated

POST

/api/events

Create an event

Organiser

PUT

/api/events/{eventId}

Update an event

Organiser

DELETE

/api/events/{eventId}

Delete an event

Organiser

GET

/api/event-types

View event types

Public/Authenticated

Categories

Method

Route

Description

Role

GET

/api/events/{eventId}/categories

View event categories

Public/Authenticated

POST

/api/events/{eventId}/categories

Create a category

Organiser

PUT

/api/categories/{categoryId}

Update a category

Organiser

DELETE

/api/categories/{categoryId}

Delete a category

Organiser

Enrolments

Method

Route

Description

Role

POST

/api/events/{eventId}/enrollments

Enrol in an event

Participant

GET

/api/events/{eventId}/enrollments

View event enrolments

Organiser

GET

/api/enrollments/me

View own enrolments

Participant

GET

/api/enrollments/{enrollmentId}

View one enrolment

Authorised user

Results

Method

Route

Description

Role

POST

/api/enrollments/{enrollmentId}/result

Capture a result

Organiser

GET

/api/results/me

View own results

Participant

GET

/api/events/{eventId}/results

View event results

Organiser

GET

/api/results/{resultId}

View one result

Authorised user

6. API and Database Alignment

The API is based directly on the database structure.

Creating an event inserts into Event.

OrganizerID must refer to an existing User.

EventTypeID must refer to an existing EventType.

Creating a category inserts into Category and uses a valid EventID.

Creating an enrolment inserts into Enrollment.

ParticipantID, EventID and CategoryID must refer to valid records.

Capturing a result inserts into Result and uses a valid EnrollmentID.

When a participant enrols, the API should check that the selected CategoryID belongs to the selected EventID. This prevents an invalid category/event combination.

7. Role-Based Access

Organiser

Organisers can:

Create, update and delete events

Manage event categories

View event enrolments

Capture results

View event results

Participant

Participants can:

Register and log in

View and update their profile

View events and categories

Enrol in events

View their own enrolments

View their own results

8. Data Validation

The SQL database applies the following controls:

Required fields use NOT NULL.

User email addresses are unique.

User roles are restricted to Organiser or Participant.

Event distance must be greater than zero.

Category age ranges cannot be invalid when both ages are supplied.

Category distance must be greater than zero when supplied.

Enrolments require valid participant, event and category records.

A participant cannot enrol in the same event twice.

Results require a valid enrolment.

An enrolment can have only one result.

Finishing position must be greater than zero.

9. Sample Data

The SQL script contains sample records for testing:

Users

John Mokoena - Organiser

Sarah Dlamini - Participant

Thabo Ndlovu - Participant

Event Types

Run

Walk

Cycle

Events

Johannesburg Fun Run

City Charity Walk

Categories

Under 20

Senior

5km Open

Sample enrolments and results are also included.

10. Testing

The database can be checked using:

SELECT * FROM [User];
SELECT * FROM EventType;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrollment;
SELECT * FROM Result;

The API should be tested to confirm that:

A user can register.

A user can log in.

An organiser can create an event.

Participants can view events.

Participants can enrol in an event.

Duplicate enrolments are rejected.

Organisers can view enrolments.

Organisers can capture results.

Participants can view their own results.

Participants cannot perform organiser-only actions.

11. Recommended Project Structure

RaceDayDB/
│
├── README.md
├── database/
│   └── RaceDayDB.sql
├── docs/
│   └── api-endpoint-plan.md
├── ERD/
│   └── ERD.png
└── api/
    └── [API implementation files]

12. How to Run the Database

Open SQL Server Management Studio.

Open the RaceDayDB.sql script.

Run the script.

Confirm that the RaceDayDB database is created.

Confirm that all six tables exist.

Confirm that the sample data has been inserted.

Run the SELECT statements at the end of the script.

The API should then be configured to connect to the RaceDayDB database.

13. Important Alignment Rules

The API, ERD and SQL database must remain consistent.

Use OrganizerID for the event organiser relationship.

Use ParticipantID for the participant relationship.

Use EventTypeID for event types.

Use CategoryID for categories.

Use EnrollmentID for results.

Use the roles Organiser and Participant.

Keep the existing foreign-key relationships.

Do not create unrelated tables.

Do not allow duplicate participant/event enrolments.

Do not allow more than one result for the same enrolment.

14. Conclusion

RaceDayDB provides a structured database for managing events, participants, categories, enrolments and results. The API endpoint plan is designed around the same entities and relationships shown in the ERD and implemented in the SQL script. Keeping these three parts aligned helps ensure that the final API behaves consistently with the database design.
