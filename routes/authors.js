const express = require("express");
const router = express.Router();
const shared_data = require("../routes/shared-data")
const _ = require('lodash');
const author_menus = [
    {
        name: "HOME",
        link: "/",
        id: "home"
    },
    {
        name: "Setting",
        link: "/authors/setting",
        id: "setting"
    }
]

/**
 * @desc Display all articles
 */
router.get("/", (req, res, next) => {
    // Select all published articles
    let query = "SELECT * FROM articles";

    // Execute the query
    db.all(query, [], (err, rows) => {
        if (err) {
            throw err;
        }
        res.render("authors/home", {
            ...shared_data,
            menus: author_menus,
            _,
            copyToClipBoard: function(link) {
                navigator.clipboard.writeText(link);
            },
            published_articles: rows.filter(e => e.article_status === 1),
            draft_articles: rows.filter(e => e.article_status === 0),
        });
    });
});

/**
 * @desc Setting page
 */
router.get("/setting", (req, res, next) => {
    // Select current setting
    let query = "SELECT * FROM authors";

    // Execute the query
    db.all(query, [], (err, rows) => {
        if (err) {
            throw err;
        }
        res.render("authors/setting", {
            ...shared_data,
            menus: author_menus,
            _,
            author: rows[0],
        });
    });
});

/**
 * @desc Update blog title and author name
 */
router.post("/setting", (req, res, next) => {
    // Update setting in authors table
    let query = "UPDATE authors SET blog_title = ?, author_name = ? WHERE author_id = ?;";
    let query_parameters = [req.body.blog_title, req.body.author_name, 1]

    // Execute the query
    db.all(query, query_parameters, (err, rows) => {
        if (err) {
            throw err;
        }
        shared_data.blog_title = req.body.blog_title;
        shared_data.author_name = req.body.author_name;
        res.redirect("/authors");
    });
})

/**
 * @desc create a draft article
 */
router.post("/articles", function (req, res, next) {
    // Create a draft article with article status = 0
    let query = `INSERT INTO articles ('article_title','author_name','article_content','article_status','created_at','published_at','last_modified','number_of_read','number_of_like') VALUES ('draft article', '${shared_data.author_name}', 'draft content', 0, datetime('now', 'localtime'), null, datetime('now', 'localtime'), 0, 0);`;

    // Execute the query
    db.run(query, [], function (err, rows) {
        if (err) {
            throw err;
        }
        res.redirect("/authors/articles/" + this.lastID);
    });
});

/**
 * @desc Edit an article by id
 * @params  id - an ID of the article
 * @body    article_title - title of the article
 *          article_content - content of the article  
 */
router.post("/articles/:id", (req, res, next) => {
    // Update the target article
    let query = "UPDATE articles SET article_title = ?, article_content = ?, last_modified = datetime('now', 'localtime') WHERE article_id = ?;";
    let query_parameters = [req.body.article_title, req.body.article_content, req.params.id]

    // Execute the query
    db.all(query, query_parameters, (err, rows) => {
        if (err) {
            throw err;
        }
        res.redirect("/authors");
    });
});

/**
 * @desc Get a update article page by article id
 */
router.get("/articles/:id", (req, res, next) => {
    // Select all published articles
    let query = "SELECT * FROM articles where article_id = ?";

    // Execute the query
    db.all(query, [req.params.id], (err, rows) => {
        if (err) {
            throw err;
        }
        res.render("authors/article", {
            ...shared_data,
            menus: author_menus,
            _,
            article: rows[0],
        });
    });
});

/**
 * @desc delete an article by article id
 */
router.get("/articles/delete/:id", (req, res, next) => {
    // delete the article
    let query = "DELETE FROM articles where article_id = ?";

    // Execute the query
    db.all(query, [req.params.id], (err, rows) => {
        if (err) {
            throw err;
        }
        res.redirect("/authors");
    });
});

/**
 * @desc publish an article by article id
 */
router.get("/articles/publish/:id", (req, res, next) => {
    // update article status of the article
    let query = "UPDATE articles SET article_status = 1, published_at = datetime('now', 'localtime') WHERE article_id = ?;";

    // Execute the query
    db.all(query, [req.params.id], (err, rows) => {
        if (err) {
            throw err;
        }
        res.redirect("/authors");
    });
});

module.exports = router;