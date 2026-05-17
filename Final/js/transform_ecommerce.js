function transform(inJson) {
  var obj = JSON.parse(inJson);

  var quantity = Number(obj.Quantity || 0);
  var unitPrice = Number(obj.UnitPrice || 0);
  var totalAmount = quantity * unitPrice;

  obj.Quantity = quantity;
  obj.UnitPrice = unitPrice;
  obj.TotalAmount = totalAmount;
  obj.Source = "pubsub_dataflow_udf";
  obj.IsHighValue = totalAmount >= 100;

  if (obj.InvoiceDate) {
    obj.InvoiceTimestamp = obj.InvoiceDate;
    obj.InvoiceHour = obj.InvoiceDate.substring(0, 13) + ":00:00";
  } else {
    obj.InvoiceTimestamp = null;
    obj.InvoiceHour = null;
  }

  return JSON.stringify(obj);
}