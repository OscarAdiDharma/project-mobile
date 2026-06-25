import pandas as pd  # type: ignore
import numpy as np  # type: ignore
import os

def generate_dataset(num_records=5000, output_path='dataset/employee_kpi_data.csv'):
    np.random.seed(42)
    
    data = {}
    
    # Identify Data
    data['employee_id'] = np.arange(1001, 1001 + num_records)
    
    # Create classes to help define metrics realistically
    # 0 = Low, 1 = Medium, 2 = High
    classes = np.random.choice([0, 1, 2], size=num_records, p=[0.2, 0.5, 0.3])
    
    # Helper to generate values based on class
    def gen_based_on_class(low_range, mid_range, high_range):
        return [
            np.random.randint(*low_range) if c == 0 else
            np.random.randint(*mid_range) if c == 1 else
            np.random.randint(*high_range)
            for c in classes
        ]

    # Performance
    data['tasks_completed'] = gen_based_on_class((20, 35), (30, 45), (40, 60))
    data['average_task_quality'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['projects_led'] = gen_based_on_class((0, 2), (1, 3), (2, 6))
    data['client_satisfaction_score'] = gen_based_on_class((0, 60), (60, 85), (85, 101))
    data['hours_worked'] = [min(np.random.normal(40, 5) if c > 0 else np.random.normal(35, 5), 60) for c in classes]
    data['hours_worked'] = [int(x) for x in data['hours_worked']]
    data['deadline_met_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['innovation_score'] = gen_based_on_class((1, 4), (4, 7), (7, 11))
    data['efficiency_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    
    # Behavior & Collaboration
    data['meetings_attended'] = gen_based_on_class((5, 10), (10, 15), (15, 21))
    data['collaboration_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['punctuality_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['training_hours_completed'] = [np.round(x, 1) for x in gen_based_on_class((5, 10), (10, 15), (15, 20))]
    data['work_engagement_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['peer_interaction_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))
    data['initiative_score'] = gen_based_on_class((1, 4), (4, 8), (8, 11))
    data['task_followup_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))

    # Communication (Optional in actual app, but included here for completeness)
    data['speech_sentiment_score'] = [np.round(np.random.uniform(-0.5, 0) if c == 0 else np.random.uniform(0, 0.5) if c == 1 else np.random.uniform(0.5, 1.0), 2) for c in classes]
    data['speech_energy_level'] = gen_based_on_class((1, 5), (4, 8), (7, 11))
    data['speech_clarity_score'] = gen_based_on_class((1, 5), (4, 8), (7, 11))
    data['tone_consistency_score'] = gen_based_on_class((1, 5), (4, 8), (7, 11))
    data['speaking_speed'] = gen_based_on_class((80, 100), (100, 130), (120, 161))
    data['pause_frequency'] = gen_based_on_class((5, 11), (2, 6), (0, 3))
    data['pitch_variation'] = gen_based_on_class((1, 4), (4, 7), (7, 11))
    data['volume_stability_score'] = gen_based_on_class((1, 5), (5, 8), (8, 11))

    # Target
    label_map = {0: 'Low', 1: 'Medium', 2: 'High'}
    data['performance_rating'] = [label_map[c] for c in classes]

    df = pd.DataFrame(data)
    
    dirname = os.path.dirname(output_path)
    if dirname:
        os.makedirs(dirname, exist_ok=True)
    df.to_csv(output_path, index=False)
    print(f"Dataset generated at {output_path} with {num_records} records.")

if __name__ == "__main__":
    generate_dataset()
