const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth");
const Item = require("../models/Item");

// Create new item
router.post("/", auth, async (req, res) => {
  try {
    const { categoryId, title, summary, description, images = [], linksTo = [], meta = {} } = req.body;

    if (!categoryId || !title) {
      return res.status(400).json({ error: "categoryId and title are required" });
    }

    const newItem = new Item({
      category: categoryId, // map frontend categoryId to backend category
      title,
      summary,
      description,
      images,   // expect array of objects { filename, fileId }
      linksTo,  // expect array of item IDs
      meta      // optional meta object
    });

    await newItem.save();
    res.status(201).json(newItem);

  } catch (err) {
    console.error("Error creating item:", err);
    res.status(500).json({ error: err.message });
  }
});

// Get all items
router.get("/", async (req, res) => {
  try {
    const items = await Item.find().populate("category").populate("linksTo");
    res.json(items);
  } catch (err) {
    console.error("Error fetching items:", err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
