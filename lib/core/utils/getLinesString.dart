int getLineCount(String text) {
  // Разделяем текст по символу новой строки (\n)
  List<String> lines = text.split('\n');
  
  // Возвращаем количество строк
  return lines.length;
}