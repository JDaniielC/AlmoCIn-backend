import TestRepository from '../repositories/test.repository';
import TestService from '../services/test.service';
import Injector from './injector';

export const di = new Injector();

// Test
di.registerRepository(TestRepository, new TestRepository());
di.registerService(
  TestService,
  new TestService(di.getRepository(TestRepository))
);
