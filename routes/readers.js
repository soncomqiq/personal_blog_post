const express = require("express");
const router = express.Router();
const shared_data = require('../routes/shared-data');
const _ = require('lodash');

const reader_menus = [
    {
        name: "HOME",
        link: "/",
        id: "home"
    }
]

/**
 * @desc Display all articles
 */
router.get("/", (req, res, next) => {
    // Select all articles which are published and order by published date
    let query = "SELECT * FROM articles where article_status = 1 order by published_at desc";

    // Execute the query
    db.all(query, [], (err, rows) => {
        if (err) {
            throw err;
        }
        res.render("readers/home", {
            ...shared_data,
            menus: reader_menus,
            homeStartingContent: "All available articles",
            _,
            articles: rows
        });
    });
});

/**
 * @desc Display a article by article id
 */
router.get("/articles/:id", (req, res, next) => {
    // Select article
    const query = "SELECT * FROM articles a LEFT OUTER JOIN comments c on a.article_id = c.article_id where a.article_id = ?"

    // Execute the query
    db.all(query, [req.params.id], (err, rows) => {
        const article = rows[0];
        const comments = [];
        if (article?.commenter_name) {
            rows.forEach(e => {
                comments.push(e);
            })
        }
        res.render("readers/article", {
            ...shared_data,
            article_id: req.params.id,
            menus: reader_menus,
            _,
            article: article,
            comments: comments
        });
    })
});

/**
 * @desc like an article by article id
 */
router.get("/articles/like/:id", (req, res, next) => {
    // update number of like of the article
    let query = "UPDATE articles SET number_of_like = ? WHERE article_id = ?;";
    let query_parameters = [Number(req.query.current_like) + 1, req.params.id]

    // Execute the query
    db.all(query, query_parameters, (err, rows) => {
        if (err) {
            throw err;
        }
        res.redirect("/readers/articles/" + req.params.id);
    });
});

/**
 * @desc like an article by article id
 */
router.post("/articles/comment/:id", (req, res, next) => {
    // update number of like of the article
    let query = "INSERT INTO comments ( 'commenter_name', 'comment_content', 'article_id' ) VALUES (?, ?, ?);";
    let query_parameters = [req.body.commenter_name, req.body.comment_content, req.params.id]

    // Execute the query
    db.all(query, query_parameters, (err, rows) => {
        if (err) {
            throw err;
        }
        res.redirect("/readers/articles/" + req.params.id);
    });
});

module.exports = router;