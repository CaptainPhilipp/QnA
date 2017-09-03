# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true, touch: true

  mount_uploader :file, FileUploader

  validates :file, presence: true
end
