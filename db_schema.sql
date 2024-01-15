
-- This makes sure that foreign_key constraints are observed and that errors will be thrown for violations
PRAGMA foreign_keys=ON;

BEGIN TRANSACTION;

-- Create your tables with SQL commands here (watch out for slight syntactical differences with SQLite vs MySQL)

CREATE TABLE IF NOT EXISTS authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    blog_title TEXT NOT NULL,
    author_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS articles (
    article_id INTEGER PRIMARY KEY AUTOINCREMENT,
    article_title TEXT NOT NULL,
    author_name TEXT NOT NULL,
    article_content TEXT NOT NULL,
    article_status INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    published_at TEXT,
    last_modified TEXT NOT NULL,
    number_of_read INTEGER NOT NULL,
    number_of_like INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS comments (
    comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    commenter_name TEXT NOT NULL,
    comment_content TEXT NOT NULL,
    article_id  INT, --the user that the email account belongs to
    FOREIGN KEY (article_id) REFERENCES articles(article_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS email_accounts (
    email_account_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email_address TEXT NOT NULL,
    user_id  INT, --the user that the email account belongs to
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert default data (if necessary here)
-- Set up current author
INSERT INTO authors ('blog_title', 'author_name') VALUES ('Series Blogger', 'John Conner');

-- Set up published articles
INSERT INTO
    articles (
        'article_id',
        'article_title',
        'author_name',
        'article_content',
        'article_status',
        'created_at',
        'published_at',
        'last_modified',
        'number_of_read',
        'number_of_like'
    )
VALUES
    (
        1,
        'EV is the new future',
        'Elon musk',
        'Tesla’s updated 2024 Model 3, previously available in Europe, China, and the Middle East, is now on sale in the United States, Canada, and Mexico.  Interior enhancements include a new eight-inch rear display for infotainment and climate control, ventilated front seats, higher quality materials, acoustic glass and customizable ambient lighting.  Exterior modifications include integrated fog lights and indicators in the main headlights, a front design optimized for aerodynamics, and connected rear lights. Two new color options have been introduced: Ultra Red and Stealth Grey. The vehicle comes in two variants: the Real Wheel Model 3 with a 272-mile range and the Long Range Model 3, now offering a slightly increased EPA estimated range of 341 miles. Model 3 Highland is not eligible for the IRA tax credit, making it comparatively more expensive than the Model Y. The Performance trim of Model 3 is still in development, and the older version is no longer available for order. However, existing stock can be purchased with a minimum $5,000 discount, plus the applicable IRA tax credit.',
        1,
        '2024-01-01 20:13:45',
        '2024-01-07 21:46:38',
        '2024-01-14 21:46:38',
        320,
        30
    );

INSERT INTO
    articles (
        'article_id',
        'article_title',
        'author_name',
        'article_content',
        'article_status',
        'created_at',
        'published_at',
        'last_modified',
        'number_of_read',
        'number_of_like'
    )
VALUES
    (
        2,
        'Bitcoin is the old future (Top Article)',
        'Shatoshi',
        'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?',
        1,
        '2024-01-02 20:13:45',
        '2024-01-14 21:46:38',
        '2024-01-14 21:46:38',
        455,
        21
    );

INSERT INTO
    articles (
        'article_id',
        'article_title',
        'author_name',
        'article_content',
        'article_status',
        'created_at',
        'published_at',
        'last_modified',
        'number_of_read',
        'number_of_like'
    )
VALUES
    (
        3,
        'This is an article',
        'Kevin Armor',
        'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isnt anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
        1,
        '2024-01-03 20:13:45',
        '2024-01-04 21:46:38',
        '2024-01-14 21:46:38',
        455,
        21
    );



-- Set up draft articles
INSERT INTO
    articles (
        'article_title',
        'author_name',
        'article_content',
        'article_status',
        'created_at',
        'published_at',
        'last_modified',
        'number_of_read',
        'number_of_like'
    )
VALUES
    (
        'This is Elon Musk',
        'Annonymous',
        'This article is currently being written by someone. It has not finished yet',
        0,
        datetime('now', 'localtime'),
        null,
        datetime('now', 'localtime'),
        0,
        0
    );

INSERT INTO
    articles (
        'article_title',
        'author_name',
        'article_content',
        'article_status',
        'created_at',
        'published_at',
        'last_modified',
        'number_of_read',
        'number_of_like'
    )
VALUES
    (
        'What you get here, and?',
        'Google',
        'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
        0,
        datetime('now', 'localtime'),
        null,
        datetime('now', 'localtime'),
        0,
        0
    );

-- Set up the published article's comments
INSERT INTO
    comments (
        'commenter_name',
        'comment_content',
        'article_id'
    )
VALUES
    (
        'MR. A',
        'Interesting article',
        1
    );
INSERT INTO
    comments (
        'commenter_name',
        'comment_content',
        'article_id'
    )
VALUES
    (
        'MR. B',
        'Are you sure?',
        1
    );

-- Set up three users
INSERT INTO users ('user_name') VALUES ('Simon Star');
INSERT INTO users ('user_name') VALUES ('Dianne Dean');
INSERT INTO users ('user_name') VALUES ('Harry Hilbert');

-- Give Simon two email addresses and Diane one, but Harry has none
INSERT INTO email_accounts ('email_address', 'user_id') VALUES ('simon@gmail.com', 1); 
INSERT INTO email_accounts ('email_address', 'user_id') VALUES ('simon@hotmail.com', 1); 
INSERT INTO email_accounts ('email_address', 'user_id') VALUES ('dianne@yahoo.co.uk', 2); 

COMMIT;

