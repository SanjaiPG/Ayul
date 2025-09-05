const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const CategorySchema = new Schema({
traditionalMethod: { type: Schema.Types.ObjectId, ref: 'TraditionalMethod', required: true },
name: { type: String, required: true },
slug: { type: String, required: true },
items: [{ type: Schema.Types.ObjectId, ref: 'Item' }],
createdAt: { type: Date, default: Date.now }
});


module.exports = mongoose.model('Category', CategorySchema);