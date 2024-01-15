// A Object which is globally used by routes
const shared_data = {
    blog_title: "Default Title",
    author_name: "Default Author name",
}

// Initial blog title and author name
db.all("SELECT * FROM authors", [], (err, rows) => {
    if (err) {
        throw err;
    }
    const { blog_title, author_name } = rows[0]
    shared_data.blog_title = blog_title;
    shared_data.author_name = author_name
});

module.exports = shared_data;