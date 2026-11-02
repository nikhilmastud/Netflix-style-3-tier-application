import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://netflix-style-3-tier-public-alb-451539084.ap-south-1.elb.amazonaws.com';

export const options = {
  vus: 5,
  duration: '30s',
  thresholds: {
    checks: ['rate>0.99'],
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<2000'],
  },
};

export default function () {
  const home = http.get(`${BASE_URL}/`);
  check(home, {
    'Homepage HTTP 200': (r) => r.status === 200,
    'Nginx response': (r) => r.body.includes('Nginx Web Server'),
  });

  const app = http.get(`${BASE_URL}/api/health`);
  check(app, {
    'API HTTP 200': (r) => r.status === 200,
    'Application UP': (r) => r.body.includes('"status":"UP"'),
  });

  const db = http.get(`${BASE_URL}/api/db-health`);
  check(db, {
    'Database HTTP 200': (r) => r.status === 200,
    'Database UP': (r) => r.body.includes('"database":"UP"'),
  });

  sleep(1);
}
