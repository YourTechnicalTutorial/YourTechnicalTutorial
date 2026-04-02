require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const dns = require('dns');

// Force using Google DNS for SRV resolution
dns.setServers(['8.8.8.8', '8.8.4.4']);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Request Logger
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

const mongoURI = process.env.MONGO_URI;

mongoose.connect(mongoURI)
  .then(() => console.log('✅ Connected to MongoDB Atlas'))
  .catch(err => console.error('❌ MongoDB Error:', err));

// Health Check
app.get('/', (req, res) => {
  res.status(200).send('✅ Backend is Alive and Connected!');
});

// Model
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});

const User = mongoose.model('User', userSchema);

// Signup
app.post('/signup', async (req, res) => {
  console.log(`[SIGNUP] attempt for: ${req.body.email}`);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      console.log(`[SIGNUP] Validation failed: missing email or password`);
      return res.status(400).json({ message: 'All fields required' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      console.log(`[SIGNUP] User already exists: ${email}`);
      return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ email, password: hashedPassword });
    await newUser.save();

    console.log(`[SIGNUP] Success: ${email}`);
    res.status(201).json({ message: 'User created successfully' });
  } catch (err) {
    console.error(`[SIGNUP] Error:`, err);
    res.status(500).json({ message: 'Signup error' });
  }
});

// Login
app.post('/login', async (req, res) => {
  console.log(`[LOGIN] attempt for: ${req.body.email}`);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'All fields required' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      console.log(`[LOGIN] User not found: ${email}`);
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      console.log(`[LOGIN] password mismatch for: ${email}`);
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    console.log(`[LOGIN] Success: ${email}`);
    res.status(200).json({ message: 'Login success', token });
  } catch (err) {
    console.error(`[LOGIN] Error:`, err);
    res.status(500).json({ message: 'Login error' });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});