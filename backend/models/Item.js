const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const ItemSchema = new Schema({
category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
title: { type: String, required: true },
slug: { type: String },
summary: { type: String },
description: { type: String },
images: [{ filename: String, fileId: Schema.Types.ObjectId }],
linksTo: [{ type: Schema.Types.ObjectId, ref: 'Item' }],
meta: {
partUsed: String,
preparation: String,
dosage: String
},
createdAt: { type: Date, default: Date.now }
});


module.exports = mongoose.model('Item', ItemSchema);