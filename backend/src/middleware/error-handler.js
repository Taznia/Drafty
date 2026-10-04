export function notFoundHandler(request, response) {
  response.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: `Route not found: ${request.method} ${request.originalUrl}`,
    },
  });
}

export function errorHandler(error, request, response, next) {
  if (response.headersSent) {
    next(error);
    return;
  }

  const statusCode = error.statusCode ?? 500;
  const message = statusCode >= 500 ? 'An unexpected server error occurred.' : error.message;

  if (statusCode >= 500) {
    console.error(error);
  }

  response.status(statusCode).json({
    error: {
      code: error.code ?? 'INTERNAL_SERVER_ERROR',
      message,
      ...(error.details ? { details: error.details } : {}),
    },
  });
}
