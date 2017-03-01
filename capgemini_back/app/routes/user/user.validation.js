const Joi = require('joi');
module.exports = exports = {
    // POST /api/users
    createUser: {
        body: {
            username: Joi.string().regex(/[A-Za-z0-9]+/).required(),
            memDate: Joi.string().required(),
        },
    },
    // UPDATE /api/users/:userId
    updateUser: {
        body: {
            username: Joi.string().required(),
            memDate: Joi.string().regex(/.*/).required(),
        },
        params: {
            userId: Joi.string().hex().required(),
        },
    },
};
