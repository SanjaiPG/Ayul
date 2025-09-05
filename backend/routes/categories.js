const express = require('express');
const router = express.Router();
const Category = require('../models/Category');
const TraditionalMethod = require('../models/TraditionalMethod');
const slugify = require('../utils/slugify');
const auth = require('../middleware/auth');


// create category under a traditional method (admin)
router.post('/', auth, async (req, res) => {
try {
const { traditionalMethodId, name } = req.body;
if (!traditionalMethodId || !name) return res.status(400).json({ msg: 'Missing fields' });
const tm = await TraditionalMethod.findById(traditionalMethodId);
if (!tm) return res.status(404).json({ msg: 'Traditional method not found' });
const slug = slugify(name);
const cat = new Category({ traditionalMethod: tm._id, name, slug });
await cat.save();
tm.categories.push(cat._id);
await tm.save();
res.json(cat);
} catch (err) {
console.error(err);
res.status(500).json({ msg: 'Server error' });
}
});


module.exports = router;