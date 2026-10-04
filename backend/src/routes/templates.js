import { Router } from 'express';

const templates = [
  { id: 'sora', name: 'Sora', slug: 'sora', isPremium: false },
  { id: 'atlas', name: 'Atlas', slug: 'atlas', isPremium: false },
  { id: 'mono', name: 'Mono', slug: 'mono', isPremium: false },
];

export const templatesRouter = Router();

templatesRouter.get('/', (request, response) => {
  response.status(200).json({ data: templates });
});
