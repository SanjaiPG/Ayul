const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const TraditionalMethodSchema = new Schema({
name: { type: String, required: true, unique: true },
slug: { type: String, required: true, unique: true },
description: { type: String },
categories: [{ type: Schema.Types.ObjectId, ref: 'Category' }],
createdAt: { type: Date, default: Date.now }
});


module.exports = mongoose.model('TraditionalMethod', TraditionalMethodSchema);