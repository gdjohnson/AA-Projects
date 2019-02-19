PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,


    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    liker_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
    users (fname, lname)
VALUES 
    ('bob', 'hat'),
    ('sally', 'lamb');

INSERT INTO     
    questions (title, body, author_id)
VALUES 
    ('Sleep?', 'Why am I so tired?', (SELECT id FROM users WHERE fname = 'bob')),
    ('What happened to my lamb?', 'He was here yesterday', (SELECT id FROM users WHERE fname = 'sally'));
    
INSERT INTO
    replies (question_id, parent_reply_id, user_id, body)
VALUES
    (1, NULL, 2, "cuz you lazy"),
    (1, 1, 1, "shut up");

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    (2, 1)