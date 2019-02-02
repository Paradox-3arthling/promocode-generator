defmodule PromocodeWeb.PromocodeControllerTest do
  use PromocodeWeb.ConnCase

  alias Promocode.EventsPromocode
  # alias Promocode.EventsPromocode.Promocode

  @create_attrs %{
    is_active: true,
    promo_code_tag: "some promo_code_tag",
    promo_code_worth: "120.5"
  }
  # @update_attrs %{
  #   is_active: false,
  #   promo_code_tag: "some updated promo_code_tag",
  #   promo_code_worth: "456.7"
  # }
  # @invalid_attrs %{is_active: nil, promo_code_tag: nil, promo_code_worth: nil}

  def fixture(:promocode) do
    {:ok, promocode} = EventsPromocode.create_promocode(@create_attrs)
    promocode
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all promocodes", %{conn: conn} do
      conn = get(conn, Routes.promocode_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create promocode" do
    # test "renders promocode when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.promocode_path(conn, :create), promocode: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]
    #
    #   conn = get(conn, Routes.promocode_path(conn, :show, id))
    #
    #   assert %{
    #            "id" => id,
    #            "is_active" => true,
    #            "promo_code_tag" => "some promo_code_tag",
    #            "promo_code_worth" => "120.5"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.promocode_path(conn, :create), promocode: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update promocode" do
    setup [:create_promocode]

    # test "renders promocode when data is valid", %{conn: conn, promocode: %Promocode{id: id} = promocode} do
    #   conn = put(conn, Routes.promocode_path(conn, :update, promocode), promocode: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]
    #
    #   conn = get(conn, Routes.promocode_path(conn, :show, id))
    #
    #   assert %{
    #            "id" => id,
    #            "is_active" => false,
    #            "promo_code_tag" => "some updated promo_code_tag",
    #            "promo_code_worth" => "456.7"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, promocode: promocode} do
    #   conn = put(conn, Routes.promocode_path(conn, :update, promocode), promocode: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete promocode" do
    setup [:create_promocode]
    #
    # test "deletes chosen promocode", %{conn: conn, promocode: promocode} do
    #   conn = delete(conn, Routes.promocode_path(conn, :delete, promocode))
    #   assert response(conn, 204)
    #
    #   assert_error_sent 404, fn ->
    #     get(conn, Routes.promocode_path(conn, :show, promocode))
    #   end
    # end
  end

  defp create_promocode(_) do
    promocode = fixture(:promocode)
    {:ok, promocode: promocode}
  end
end
