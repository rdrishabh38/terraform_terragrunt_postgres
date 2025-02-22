"model for core.product table"

from sqlalchemy import CHAR, Column, DateTime, String, Index

from models.base import Base


class Product(Base):

    """model class for table core.product"""

    __tablename__ = "product"
    __table_args__ = (
        Index("product_PK_index", "product_key"),
        {
            "schema": "core",
            "comment": "product table in core schema"
        },
    )

    product_key = Column(CHAR(32), primary_key=True, nullable=False)
    create_timestamp = Column(DateTime(True), nullable=False)
    update_timestamp = Column(DateTime(True), nullable=False)
    record_effective_timestamp = Column(DateTime(True), nullable=False)
    record_expiration_timestamp = Column(DateTime(True), nullable=False)
    current_record_indicator = Column(CHAR(1), nullable=False)
    product_code = Column(String(255), nullable=False)
    product_name = Column(String(255), nullable=False)
    product_description = Column(String(255), nullable=False)