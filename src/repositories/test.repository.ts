import TestEntity from '../entities/test.entity';
import BaseRepository from './base.repository';

class TestRepository extends BaseRepository<TestEntity> {
  constructor() {
    super('tests');
  }

  public async getTests(): Promise<TestEntity[]> {
    return await this.findAll();
  }

  public async getTest(id: string): Promise<TestEntity | null> {
    return await this.findOne((item) => item.id === id);
  }

  public async createTest(data: TestEntity): Promise<void> {
    await this.add(data);
  }

  public async updateTest(id: string, data: TestEntity): Promise<void> {
    await this.update(id, data);
  }

  public async deleteTest(id: string): Promise<void> {
    await this.delete(id);
  }
}

export default TestRepository;
