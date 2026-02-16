const request = require('supertest')
const app = require('../app')

describe('Test suite users feat', () => {
  it('GET /users return 200', async () => {
    const res = await request(app).get('/users')

    expect(res.status).toEqual(200)
  })
})
