CREATE DATABASE RaceDayDB;

/*  User */

CREATE TABLE [User]
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName VARCHAR(50) NOT NULL,

    LastName VARCHAR(50) NOT NULL,

    Email VARCHAR(100) NOT NULL UNIQUE,

    PasswordHash VARCHAR(255) NOT NULL,

    PhoneNumber VARCHAR(20) NOT NULL,

    Role VARCHAR(20) NOT NULL,

    CONSTRAINT CK_User_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO


/*  EventType */

CREATE TABLE EventType
(
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,

    TypeName VARCHAR(20) NOT NULL UNIQUE
);
GO


/* Event */

CREATE TABLE Event
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,

    OrganizerID INT NOT NULL,

    EventName VARCHAR(100) NOT NULL,

    Description VARCHAR(500) NOT NULL,

    EventDate DATE NOT NULL,

    Location VARCHAR(150) NOT NULL,

    Distance DECIMAL(6,2) NOT NULL,

    EventTypeID INT NOT NULL,

    CONSTRAINT FK_Event_Organizer
        FOREIGN KEY (OrganizerID)
        REFERENCES [User](UserID),

    CONSTRAINT FK_Event_EventType
        FOREIGN KEY (EventTypeID)
        REFERENCES EventType(EventTypeID),

    CONSTRAINT CK_Event_Distance
        CHECK (Distance > 0)
);
GO


/*  Category */

CREATE TABLE Category
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,

    EventID INT NOT NULL,

    CategoryName VARCHAR(100) NOT NULL,

    MinimumAge INT NULL,

    MaximumAge INT NULL,

    CategoryDistance DECIMAL(6,2) NULL,

    CONSTRAINT FK_Category_Event
        FOREIGN KEY (EventID)
        REFERENCES Event(EventID),

    CONSTRAINT CK_Category_Age
        CHECK
        (
            MinimumAge IS NULL
            OR MaximumAge IS NULL
            OR MinimumAge <= MaximumAge
        ),

    CONSTRAINT CK_Category_Distance
        CHECK
        (
            CategoryDistance IS NULL
            OR CategoryDistance > 0
        )
);
GO


/*  Enrollment */

CREATE TABLE Enrollment
(
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,

    ParticipantID INT NOT NULL,

    EventID INT NOT NULL,

    CategoryID INT NOT NULL,

    EnrollmentDate DATE NOT NULL
        DEFAULT GETDATE(),

    CONSTRAINT FK_Enrollment_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES [User](UserID),

    CONSTRAINT FK_Enrollment_Event
        FOREIGN KEY (EventID)
        REFERENCES Event(EventID),

    CONSTRAINT FK_Enrollment_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID),

    CONSTRAINT UQ_Enrollment_Participant_Event
        UNIQUE (ParticipantID, EventID)
);
GO


/*  Result */

CREATE TABLE Result
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,

    EnrollmentID INT NOT NULL UNIQUE,

    FinishTime TIME NOT NULL,

    FinishingPosition INT NOT NULL,

    CONSTRAINT FK_Result_Enrollment
        FOREIGN KEY (EnrollmentID)
        REFERENCES Enrollment(EnrollmentID),

    CONSTRAINT CK_Result_Position
        CHECK (FinishingPosition > 0)
);
GO


/* INSERT EVENT TYPES */

INSERT INTO EventType (TypeName)
VALUES
('Run'),
('Walk'),
('Cycle');
GO


/* INSERT USERS */

INSERT INTO [User]
(
    FirstName,
    LastName,
    Email,
    PasswordHash,
    PhoneNumber,
    Role
)
VALUES
(
    'John',
    'Mokoena',
    'john@example.com',
    'HASHED_PASSWORD_1',
    '0712345678',
    'Organiser'
),
(
    'Sarah',
    'Dlamini',
    'sarah@example.com',
    'HASHED_PASSWORD_2',
    '0723456789',
    'Participant'
),
(
    'Thabo',
    'Ndlovu',
    'thabo@example.com',
    'HASHED_PASSWORD_3',
    '0734567890',
    'Participant'
);
GO


/* INSERT EVENTS */

INSERT INTO Event
(
    OrganizerID,
    EventName,
    Description,
    EventDate,
    Location,
    Distance,
    EventTypeID
)
VALUES
(
    1,
    'Johannesburg Fun Run',
    'Annual community running event.',
    '2026-10-10',
    'Johannesburg',
    10.00,
    1
),
(
    1,
    'City Charity Walk',
    'Community charity walking event.',
    '2026-11-15',
    'Pretoria',
    5.00,
    2
);
GO


/* INSERT CATEGORIES */

INSERT INTO Category
(
    EventID,
    CategoryName,
    MinimumAge,
    MaximumAge,
    CategoryDistance
)
VALUES
(
    1,
    'Under 20',
    0,
    19,
    10.00
),
(
    1,
    'Senior',
    20,
    NULL,
    10.00
),
(
    2,
    '5km Open',
    NULL,
    NULL,
    5.00
);
GO


/* INSERT ENROLMENT */

INSERT INTO Enrollment
(
    ParticipantID,
    EventID,
    CategoryID
)
VALUES
(
    2,
    1,
    2
),
(
    3,
    1,
    2
),
(
    2,
    2,
    3
);
GO


/* INSERT RESULTS */

INSERT INTO Result
(
    EnrollmentID,
    FinishTime,
    FinishingPosition
)
VALUES
(
    1,
    '01:05:30',
    1
),
(
    2,
    '01:10:45',
    2
);
GO


/* DISPLAY TABLES */

SELECT * FROM [User];

SELECT * FROM EventType;

SELECT * FROM Event;

SELECT * FROM Category;

SELECT * FROM Enrollment;

SELECT * FROM Result;
GO