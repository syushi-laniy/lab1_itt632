const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Enable CORS
app.use(cors());

// Mock news data
const newsData = [
{
title: "Breaking News: Flutter Rocks!",
description: "Flutter continues to dominate as the favorite cross-platform framework.",
urlToImage: "https://picsum.photos/200",
url: "https://flutter.dev"
},

{
title: "Node.js for APIs",
description: "Learn how Node.js simplifies backend development.",
urlToImage: "https://picsum.photos/201",
url: "https://nodejs.org"
},

{
title: "Tech Trends 2025",
description: "Explore the top tech trends for this year.",
urlToImage: "https://picsum.photos/202",
url: "https://www.bbc.com/news/technology"
},

{
title: "AI Revolution in 2025",
description: "Artificial Intelligence is transforming modern industries.",
urlToImage: "https://picsum.photos/203",
url: "https://openai.com"
},

{
title: "Cybersecurity Alert",
description: "Experts warn users about new phishing attacks.",
urlToImage: "https://picsum.photos/204",
url: "https://www.cnn.com/tech"
},

{
title: "Tesla Expands in Asia",
description: "Tesla plans to expand operations across Asia.",
urlToImage: "https://picsum.photos/205",
url: "https://www.tesla.com"
}
];

// API endpoint
app.get('/news', (req, res) => {

const page = parseInt(req.query.page) || 1;
const pageSize = 3;

const start = (page - 1) * pageSize;
const end = start + pageSize;

const paginatedNews = newsData.slice(start, end);

res.json(paginatedNews);

});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});