const express = require("express");
const app = express();
const PORT = 4000;

// Serve static files (like CSS)
app.use(express.static("public"));

// Route for home page
app.get("/", (req, res) => {
  res.sendFile(__dirname + "/public/index.html");
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});

