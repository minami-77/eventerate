class User < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_many :collaborators, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :tasks_users, dependent: :destroy
  has_many :tasks, through: :tasks_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :username, presence: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true
end
