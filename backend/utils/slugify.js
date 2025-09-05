module.exports = function slugify(text) {
return text
.toString()
.toLowerCase()
.trim()
.replace(/[^a-z0-9 -]/g, '')
.replace(/\s+/g, '-')
.replace(/-+/g, '-');
};