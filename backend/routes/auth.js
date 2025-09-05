const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');


// register (for initial admin creation)
router.post('/register', async (req, res) => {
try {
const { email, password, name } = req.body;
if (!email || !password) return res.status(400).json({ msg: 'Missing fields' });
const existing = await User.findOne({ email });
if (existing) return res.status(400).json({ msg: 'User already exists' });
const hash = await bcrypt.hash(password, 10);
const user = new User({ email, name, passwordHash: hash });
await user.save();
return res.json({ msg: 'User created' });
} catch (err) {
console.error(err);
res.status(500).json({ msg: 'Server error' });
}
});


// login
router.post('/login', async (req, res) => {
try {
const { email, password } = req.body;
const user = await User.findOne({ email });
if (!user) return res.status(401).json({ msg: 'Invalid credentials' });
const ok = await user.verifyPassword(password);
if (!ok) return res.status(401).json({ msg: 'Invalid credentials' });
const token = jwt.sign({ id: user._id, role: user.role, email: user.email }, process.env.JWT_SECRET, {
expiresIn: '7d'
});
res.json({ token, user: { email: user.email, name: user.name, role: user.role } });
} catch (err) {
console.error(err);
res.status(500).json({ msg: 'Server error' });
}
});


module.exports = router;