const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const dbPath = path.join(__dirname, 'db.json'); // Path to the JSON database

app.use(express.json()); // Middleware to parse JSON request bodies

// Helper to read from db.json
const readData = () => {
  try {
    const rawData = fs.readFileSync(dbPath, 'utf8'); // Read file as a string
    return JSON.parse(rawData); // Parse to an object
  } catch (error) {
    console.error('Error reading db.json:', error);
    return { teams: [] }; // Return default if file is empty or doesn't exist
  }
};

// Helper to write to db.json
const writeData = (data) => {
  try {
    fs.writeFileSync(dbPath, JSON.stringify(data, null, 2), 'utf8'); // Write to file
  } catch (error) {
    console.error('Error writing to db.json:', error);
  }
};

// GET /teams - Fetch all teams
app.get('/teams', (req, res) => {
  const data = readData(); // Read current data from db.json
  res.json(data); // Respond with the data
});

// POST /teams - Update teams in db.json
app.post('/teams', (req, res) => {
  const { teams } = req.body; // Extract 'teams' array from request body

  if (!Array.isArray(teams)) {
    return res.status(400).json({ error: '"teams" should be an array.' }); // Validate input
  }

  const db = { teams }; // Overwrite the data with the new teams array
  writeData(db); // Write to db.json

  console.log('db.json updated successfully with:', db); // Log update for debugging
  res.status(200).json({ message: 'Teams updated successfully.', teams });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
