require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @regular_user = users(:marie)
  end

  test "should redirect non-admin users" do
    sign_in @regular_user
    get admin_root_path

    assert_redirected_to root_path
    assert_match /non autorisé/, flash[:alert]
  end

  test "should allow admin access" do
    sign_in @admin
    get admin_root_path

    assert_response :success
    assert_select 'h1', /Dashboard Administrateur/
  end

  test "should display correct stats" do
    sign_in @admin
    get admin_root_path

    assert_response :success

    # Vérifier que les stats sont affichées
    assert_select '.title', text: User.count.to_s
    assert_select '.title', text: Event.count.to_s
  end
end
