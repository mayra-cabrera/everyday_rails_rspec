require 'spec_helper'

describe "Contact" do

  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  it "is valid with a firstname, lastname and email" do
    contact = build(:contact, firstname: "Aaron", lastname: "Summer", email: "test@example.com")
    expect(contact).to be_valid
  end

  it "is invalid without a firstname" do
    contact = build(:contact, firstname: nil)
    expect(contact).to have(1).errors_on(:firstname)
  end 

  it "is invalid without a lastname" do
    contact = build(:contact, lastname: nil)
    expect(contact).to have(1).errors_on(:lastname)
  end

  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    expect(contact).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicate email address" do
    create(:contact, firstname: "Joe", lastname: "Tester", email: "email@example.com")
    contact = build(:contact, firstname: "Aaron", lastname: "Tester", email: "email@example.com")
    expect(contact).to have(1).errors_on(:email)
  end

  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: "John", lastname: "Doe", email: "johndoe@example.com")
    expect(contact.name).to eq("John Doe")
  end

  describe "filter last name by letter" do
    before :each do
      @smith = create(:contact, firstname: "John", lastname: "Smith", email: "jsmith@example.com")
      @jones = create(:contact, firstname: "Tim", lastname: "Jones", email: "tjones@example.com")
      @johnson = create(:contact, firstname: "John", lastname: "Johnson", email: "jjohnson@example.com")
    end

    context "matching letters" do
      it "returns a sorted array of result that match" do
        expect(Contact.by_letter("J")).to eq [@johnson, @jones]
      end
    end

    context "non-matching letters" do
      it "excludes contact that doesn't match" do
        expect(Contact.by_letter("J")).to_not include @smith
      end
    end
  end  
end