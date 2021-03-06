class OldArticleDeletionWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly.day(:tuesday).hour_of_day(12) }

  sidekiq_options queue: :cleanup,
                  retry: 10,
                  backtrace: true

  def perform
    ref_ids = BusinessTransaction.pluck(:article_id) # could get dangerous in the future with more sales
    Article.where.not(id: ref_ids).where(state: :closed).where("updated_at <= ?", 1.month.ago).select(:id).find_in_batches(batch_size: 100) do |group|
      OldArticleDeletionWorker.delay(queue: :cleanup).do_delete(group.map(&:id))
    end
  end

  def self.do_delete ids
    Article.where(id: ids).delete_all
  end
end
