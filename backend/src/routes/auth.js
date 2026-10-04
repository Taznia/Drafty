import { Router } from 'express';

import { asyncHandler } from '../middleware/async-handler.js';
import { authenticate } from '../middleware/authenticate.js';
import { currentUser, login, logout, register } from '../controllers/auth.js';

export const authRouter = Router();

authRouter.post('/register', asyncHandler(register));
authRouter.post('/login', asyncHandler(login));
authRouter.get('/me', authenticate, asyncHandler(currentUser));
authRouter.post('/logout', authenticate, logout);