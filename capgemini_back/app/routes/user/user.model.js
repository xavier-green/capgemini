const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const APIError = require('../../helpers/APIError');
/**
 * User Schema
 */
const UserSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        index: 1,
    },
    memDate: {
        type:String,
        required:true,
    },
    authNumber: {
      type:Number,
      default: 0,
    },
    frequencyParameters: {
      registered: { type:Boolean, required:true, default:false },
      frequency: { type:Number},
    }
});
/**
 * Add your
 * - pre-save hooks
 * - validations
 * - virtuals
 */
/**
 * Methods
 */
UserSchema.method({
});
/**
 * Statics
 */
UserSchema.statics = {
    /**
     * Get user
     * @param {ObjectId} id - The objectId of user.
     * @returns {Promise<User, APIError>}
     */
    get(id) {
        return this.findById(id)
            .execAsync().then((user) => {
                if (user) {
                    return user;
                }
                const err = new APIError('No such user exists!', httpStatus.NOT_FOUND);
                return Promise.reject(err);
            });
    },
    /**
     * Get user
     * @param {ObjectId} name - The object username of user.
     * @returns {Promise<User, APIError>}
     */
    get(name) {
        return this.findOne({username:name})
            .execAsync().then((user) => {
                if (user) {
                    return user;
                }
                const err = new APIError('No such user exists!', httpStatus.NOT_FOUND);
                return Promise.reject(err);
            });
    },
    /**
     * List users in descending order of 'createdAt' timestamp.
     * @param {number} skip - Number of users to be skipped.
     * @param {number} limit - Limit number of users to be returned.
     * @returns {Promise<User[]>}
     */
    list({ skip = 0, limit = 50 } = {}) {
        return this.find()
            .sort({ authNumber: -1 })
            .skip(skip)
            .limit(limit)
            .execAsync();
    },
};
/**
 * @typedef User
 */
module.exports = exports = mongoose.model('User', UserSchema);
