import pandas as pd
import os

def merge_kaggle_datasets():
    # File paths
    base_dir = os.path.dirname(os.path.abspath(__file__))
    structured_path = os.path.join(base_dir, 'structured_data.csv')
    behavior_path = os.path.join(base_dir, 'behavior_logs.csv')
    audio_path = os.path.join(base_dir, 'audio_features.csv')
    output_path = os.path.join(base_dir, 'employee_kpi_data.csv')

    print("Checking for Kaggle files...")
    if not os.path.exists(structured_path) or not os.path.exists(behavior_path) or not os.path.exists(audio_path):
        print("❌ Error: Pastikan file structured_data.csv, behavior_logs.csv, dan audio_features.csv sudah ada di folder backend/dataset/")
        return

    print("Membaca file CSV...")
    # Read the datasets
    df_structured = pd.read_csv(structured_path)
    df_behavior = pd.read_csv(behavior_path)
    df_audio = pd.read_csv(audio_path)

    print("Menggabungkan file berdasarkan employee_id...")
    # Merge datasets on employee_id
    # behavior_logs and audio_features might also have performance_rating, so we drop it before merging to avoid duplicate columns
    
    if 'performance_rating' in df_behavior.columns:
        df_behavior = df_behavior.drop(columns=['performance_rating'])
    if 'performance_rating' in df_audio.columns:
        df_audio = df_audio.drop(columns=['performance_rating'])

    # Merge
    df_merged = df_structured.merge(df_behavior, on='employee_id', how='inner')
    df_merged = df_merged.merge(df_audio, on='employee_id', how='inner')

    # Save to employee_kpi_data.csv
    df_merged.to_csv(output_path, index=False)
    
    print(f"✅ Selesai! Data berhasil digabung menjadi 1 file.")
    print(f"Total baris: {len(df_merged)}")
    print(f"File tersimpan di: {output_path}")

if __name__ == "__main__":
    merge_kaggle_datasets()
