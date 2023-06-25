import TestEntity from '../entities/test.entity';
import TestModel from '../models/test.model';
import TestRepository from '../repositories/test.repository';
import { HttpNotFoundError } from '../utils/errors/http.error';

class TestServiceMessageCode {
  public static readonly test_not_found = 'test_not_found';
}

class TestService {
  private testRepository: TestRepository;

  constructor(testRepository: TestRepository) {
    this.testRepository = testRepository;
  }

  public async getTests(): Promise<TestModel[]> {
    const testsEntity = await this.testRepository.getTests();

    const testsModel = testsEntity.map((test) => new TestModel(test));

    return testsModel;
  }

  public async getTest(id: string): Promise<TestModel> {
    const testEntity = await this.testRepository.getTest(id);

    if (!testEntity) {
      throw new HttpNotFoundError({
        msg: 'Test not found',
        msgCode: TestServiceMessageCode.test_not_found,
      });
    }

    const testModel = new TestModel(testEntity);

    return testModel;
  }

  public async createTest(data: TestEntity): Promise<void> {
    await this.testRepository.add(data);
  }

  public async updateTest(id: string, data: TestEntity): Promise<void> {
    await this.testRepository.update(id, data);
  }

  public async deleteTest(id: string): Promise<void> {
    await this.testRepository.delete(id);
  }
}

export default TestService;
