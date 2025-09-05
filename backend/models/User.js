const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const Schema = mongoose.Schema;


const UserSchema = new Schema({
email: { type: String, unique: true, required: true },
name: { type: String },
passwordHash: { type: String, required: true },
role: { type: String, enum: ['admin', 'user'], default: 'admin' },
createdAt: { type: Date, default: Date.now }
});


UserSchema.methods.verifyPassword = function (password) {
return bcrypt.compare(password, this.passwordHash);
};


module.exports = mongoose.model('User', UserSchema);