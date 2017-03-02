const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const config = require('../../../config/env');

const Schema = mongoose.Schema
const ObjectId = Schema.Types.ObjectId;
const autoIncrement = require('mongoose-auto-increment');

var connection = mongoose.createConnection(config.db, config.mongo);
 
autoIncrement.initialize(connection);

const ImageSchema = new Schema({
    username: {
        type: String,
        required: true
    },
    imageData: {
        type:String,
        required:true,
    },
    votes: {
        type:Number,
        default: 0,
    },
});

ImageSchema.plugin(autoIncrement.plugin, 'Image');

ImageSchema.statics = {
    list({ skip = 0, limit = 50 } = {}) {
        return this.find()
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .execAsync();
    },
    vote() {
        return this.find()
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .execAsync();
    },
};

module.exports = exports = mongoose.model('Image', ImageSchema);
