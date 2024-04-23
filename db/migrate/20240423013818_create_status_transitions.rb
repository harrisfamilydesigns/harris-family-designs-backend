class CreateStatusTransitions < ActiveRecord::Migration[7.1]
  def change
    create_table :status_transitions do |t|
      t.references :transitionable, polymorphic: true, null: false
      t.string :from
      t.string :to

      t.datetime :created_at, null: false

      t.index %i[transitionable_type transitionable_id created_at], name: "index_status_transitions_parent"
    end

    return if Thrifter.where.not(status: nil).any?

    Thrifter.find_each do |thrifter|
      next if thrifter.status.nil?

      StatusTransition.create!(
        transitionable: thrifter,
        from: nil,
        to: thrifter.status,
        created_at: thrifter.created_at
      )
    end

    remove_column :thrifters, :status, :string
  end
end
