const express = require('express');
const router = express.Router();
const TraditionalMethod = require('../models/TraditionalMethod');
const slugify = require('../utils/slugify');
const auth = require('../middleware/auth');


// list methods (populated categories)
router.get('/', async (req, res) => {
try {
const methods = await TraditionalMethod.find().populate({ path: 'categories', select: 'name slug' });
res.json(methods);
} catch (err) {
console.error(err);
res.status(500).json({ msg: 'Server error' });
}
});


// create method (admin)
router.post('/', auth, async (req, res) => {
try {
const { name, description } = req.body;
if (!name) return res.status(400).json({ msg: 'Name required' });
const slug = slugify(name);
const existing = await TraditionalMethod.findOne({ slug });
if (existing) return res.status(400).json({ msg: 'Method already exists' });
const m = new TraditionalMethod({ name, description, slug });
await m.save();
res.json(m);
} catch (err) {
console.error(err);
res.status(500).json({ msg: 'Server error' });
}
});


module.exports = router;