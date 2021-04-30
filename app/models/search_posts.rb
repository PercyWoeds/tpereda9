include Utils

class SearchPosts
  attr_reader :where, :what, :order

  def initialize(supplier_id,document_id,moneda_id,documento, query, order_by_title, desc_order)
    @where = ""
    @what = {}
    @order = ""

    commit_search(supplier_id,document_id,moneda_id , query, order_by_title, desc_order)
  end

  private

  def commit_search(supplier_id,document_id,moneda_id,documento, query, order_by_title, desc_order)

    unless supplier_id.nil?
      @where << "supplier_id = #{supplier_id}"
      @what[:author_id] = supplier_id
    end



    unless document_id.nil?
      unless @where.blank?
        @where << ' AND '
      end

      @where << "document_id = #{document_id}"
      @what[:document_id] = document_id
    end


    unless moneda_id.nil?
      unless @where.blank?
        @where << ' AND '
      end

      @where << "moneda_id = #{moneda_id}"
      @what[:moneda_id] = moneda_id
    end

  unless documento.nil?
      unless @where.blank?
        @where << ' AND '
      end

      @where << "documento_id = #{documento_id}"
      @what[:documento_id] = documento_id
    end


    unless query.blank?
      unless @where.empty?
        @where << ' AND '
      end

      @where << "(#{case_insensitive_search(:documento)}"
      @what[:documento] = is_like(query)

      @where << ' OR ' << "#{case_insensitive_search(:supplier_id)})"
      @what[:supplier_id] = is_like(query)
    end

    if order_by_title
      @order << 'documento '
    else
      @order << 'updated_at '
    end

    if desc_order
      @order << 'DESC'
    else
      @order << 'ASC'
    end
  end

end
