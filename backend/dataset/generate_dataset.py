import pandas as pd
import numpy as np
import os

def generate_dataset(num_records=5000, output_path='dataset/employee_kpi_data.csv'):
    np.random.seed(42)

    data = {}

    data['employee_id'] = np.arange(1001, 1001 + num_records)

    # 0 = Low, 1 = Medium, 2 = High
    classes = np.random.choice([0, 1, 2], size=num_records, p=[0.2, 0.5, 0.3])

    # Helper: generate from normal distribution with overlap between classes
    # Each class has a mean and std; ranges naturally overlap
    def gen_normal(low_mean, low_std, mid_mean, mid_std, high_mean, high_std,
                   clip_min=None, clip_max=None, as_int=False):
        vals = np.zeros(num_records)
        for c, lm, ls, mm, ms, hm, hs in zip(classes,
                [low_mean]*num_records, [low_std]*num_records,
                [mid_mean]*num_records, [mid_std]*num_records,
                [high_mean]*num_records, [high_std]*num_records):
            idx = np.where(classes == c)[0]
            vals[idx] = np.random.normal(
                [lm, mm, hm][c],
                [ls, ms, hs][c],
                size=len(idx)
            )
        if clip_min is not None:
            vals = np.maximum(vals, clip_min)
        if clip_max is not None:
            vals = np.minimum(vals, clip_max)
        if as_int:
            vals = np.round(vals).astype(int)
        return vals

    # Performance — overlapping normal distributions
    # Low: mean~30, Mid: mean~40, High: mean~50 (with overlap)
    data['tasks_completed'] = gen_normal(
        30, 6,  40, 7,  50, 7,
        clip_min=10, clip_max=70, as_int=True)

    data['average_task_quality'] = gen_normal(
        4.0, 1.5,  6.0, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['projects_led'] = gen_normal(
        1.0, 1.0,  2.0, 1.2,  3.5, 1.5,
        clip_min=0, clip_max=10, as_int=True)

    data['client_satisfaction_score'] = gen_normal(
        55, 18,  72, 15,  88, 12,
        clip_min=0, clip_max=100, as_int=True)

    data['hours_worked'] = gen_normal(
        35, 6,  40, 5,  42, 6,
        clip_min=20, clip_max=60, as_int=True)

    data['deadline_met_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['innovation_score'] = gen_normal(
        3.5, 1.5,  5.5, 1.5,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['efficiency_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    # Behavior & Collaboration
    data['meetings_attended'] = gen_normal(
        8, 3,  12, 3,  17, 3,
        clip_min=2, clip_max=25, as_int=True)

    data['collaboration_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['punctuality_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['training_hours_completed'] = gen_normal(
        8, 3,  12, 3,  17, 3,
        clip_min=2, clip_max=25, as_int=False)
    data['training_hours_completed'] = np.round(data['training_hours_completed'], 1)

    data['work_engagement_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['peer_interaction_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    data['initiative_score'] = gen_normal(
        3.5, 1.5,  5.5, 1.8,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['task_followup_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    # Communication
    data['speech_sentiment_score'] = gen_normal(
        -0.15, 0.25,  0.25, 0.25,  0.7, 0.2,
        clip_min=-0.5, clip_max=1.0, as_int=False)
    data['speech_sentiment_score'] = np.round(data['speech_sentiment_score'], 2)

    data['speech_energy_level'] = gen_normal(
        4.0, 2.0,  6.0, 1.8,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['speech_clarity_score'] = gen_normal(
        4.0, 2.0,  6.0, 1.8,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['tone_consistency_score'] = gen_normal(
        4.0, 2.0,  6.0, 1.8,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['speaking_speed'] = gen_normal(
        90, 15,  115, 15,  140, 15,
        clip_min=60, clip_max=180, as_int=True)

    data['pause_frequency'] = gen_normal(
        7, 2.5,  4, 2.0,  2, 1.5,
        clip_min=0, clip_max=15, as_int=True)

    data['pitch_variation'] = gen_normal(
        4.0, 2.0,  6.0, 1.8,  8.0, 1.5,
        clip_min=1, clip_max=10, as_int=True)

    data['volume_stability_score'] = gen_normal(
        4.5, 1.8,  6.5, 1.5,  8.5, 1.2,
        clip_min=1, clip_max=10, as_int=True)

    # Target
    label_map = {0: 'Low', 1: 'Medium', 2: 'High'}
    data['performance_rating'] = [label_map[c] for c in classes]

    df = pd.DataFrame(data)

    dirname = os.path.dirname(output_path)
    if dirname:
        os.makedirs(dirname, exist_ok=True)
    df.to_csv(output_path, index=False)
    print(f"Dataset generated at {output_path} with {num_records} records.")
    print(f"Class distribution: {df['performance_rating'].value_counts().to_dict()}")

if __name__ == "__main__":
    generate_dataset()
