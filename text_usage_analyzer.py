#!/usr/bin/env python3
"""
أداة لتحليل استخدام النصوص في مشروع Flutter
تقوم بفحص النصوص المُعرّفة مقابل النصوص المُستخدمة فعلياً
"""

import os
import re
import json
from typing import Set, Dict, List, Tuple

def extract_defined_texts(text_provider_path: str) -> Dict[str, Set[str]]:
    """استخراج النصوص المُعرّفة من ملف TextProvider"""
    with open(text_provider_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # البحث عن خريطة النصوص
    texts_pattern = r"'([^']+)':\s*\{([^}]+)\}"
    matches = re.findall(texts_pattern, content, re.DOTALL)
    
    defined_texts = {}
    for lang, text_block in matches:
        keys = set()
        # استخراج المفاتيح من كتلة النص
        key_pattern = r"'([^']+)':"
        text_keys = re.findall(key_pattern, text_block)
        keys.update(text_keys)
        defined_texts[lang] = keys
    
    return defined_texts

def extract_used_texts(lib_path: str) -> Set[str]:
    """استخراج النصوص المُستخدمة من ملفات المشروع"""
    used_texts = set()
    
    for root, dirs, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # البحث عن استخدامات getText
                    get_text_pattern = r"getText\(['\"]([^'\"]+)['\"]\)"
                    matches = re.findall(get_text_pattern, content)
                    used_texts.update(matches)
                    
                    # البحث عن استخدامات getTextWithParams
                    get_text_params_pattern = r"getTextWithParams\(['\"]([^'\"]+)['\"]\s*,"
                    matches = re.findall(get_text_params_pattern, content)
                    used_texts.update(matches)
                    
                except Exception as e:
                    print(f"خطأ في قراءة الملف {file_path}: {e}")
    
    return used_texts

def analyze_text_usage(project_path: str) -> Dict:
    """تحليل استخدام النصوص في المشروع"""
    text_provider_path = os.path.join(project_path, 'lib', 'presentation', 'providers', 'text_provider.dart')
    lib_path = os.path.join(project_path, 'lib')
    
    print("🔍 استخراج النصوص المُعرّفة...")
    defined_texts = extract_defined_texts(text_provider_path)
    
    print("🔍 استخراج النصوص المُستخدمة...")
    used_texts = extract_used_texts(lib_path)
    
    # تحليل البيانات
    analysis = {}
    
    for lang, defined_keys in defined_texts.items():
        unused_texts = defined_keys - used_texts
        missing_texts = used_texts - defined_keys
        used_count = len(defined_keys & used_texts)
        
        analysis[lang] = {
            'total_defined': len(defined_keys),
            'total_used': used_count,
            'usage_percentage': (used_count / len(defined_keys)) * 100 if defined_keys else 0,
            'unused_texts': sorted(list(unused_texts)),
            'missing_texts': sorted(list(missing_texts)) if lang == 'ar' else []  # فقط للعربية
        }
    
    return analysis, used_texts

def generate_report(analysis: Dict, used_texts: Set[str], output_path: str):
    """إنشاء تقرير مفصل"""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# تقرير تحليل استخدام النصوص\n\n")
        
        f.write("## ملخص عام\n")
        f.write(f"- إجمالي النصوص المُستخدمة في الكود: {len(used_texts)}\n\n")
        
        for lang, data in analysis.items():
            lang_name = "العربية" if lang == 'ar' else "الإنجليزية"
            f.write(f"## {lang_name} ({lang})\n")
            f.write(f"- إجمالي النصوص المُعرّفة: {data['total_defined']}\n")
            f.write(f"- النصوص المُستخدمة: {data['total_used']}\n")
            f.write(f"- نسبة الاستخدام: {data['usage_percentage']:.1f}%\n\n")
            
            if data['unused_texts']:
                f.write(f"### النصوص غير المُستخدمة ({len(data['unused_texts'])}):\n")
                for text in data['unused_texts']:
                    f.write(f"- `{text}`\n")
                f.write("\n")
            
            if data['missing_texts']:
                f.write(f"### النصوص المفقودة ({len(data['missing_texts'])}):\n")
                for text in data['missing_texts']:
                    f.write(f"- `{text}`\n")
                f.write("\n")

def main():
    project_path = r"C:\Users\MR_CODER\Desktop\media_player_app"
    output_path = os.path.join(project_path, "text_usage_report.md")
    
    print("📊 تحليل استخدام النصوص في المشروع...")
    
    try:
        analysis, used_texts = analyze_text_usage(project_path)
        
        print("\n📈 النتائج:")
        for lang, data in analysis.items():
            lang_name = "العربية" if lang == 'ar' else "الإنجليزية"
            print(f"\n{lang_name}:")
            print(f"  - المُعرّف: {data['total_defined']}")
            print(f"  - المُستخدم: {data['total_used']}")
            print(f"  - نسبة الاستخدام: {data['usage_percentage']:.1f}%")
            print(f"  - غير مُستخدم: {len(data['unused_texts'])}")
            if data['missing_texts']:
                print(f"  - مفقود: {len(data['missing_texts'])}")
        
        print(f"\n📝 إنشاء التقرير: {output_path}")
        generate_report(analysis, used_texts, output_path)
        
        print("✅ تم إنشاء التقرير بنجاح!")
        
    except Exception as e:
        print(f"❌ خطأ: {e}")

if __name__ == "__main__":
    main()
